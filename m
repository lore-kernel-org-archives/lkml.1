Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab0BEHUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:20:34 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36382 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab0BEHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PWjLEV2hZIrZdjR6cZVXsNdFZB+TwDtFoUH+maLHWjGf4igmmtxsdWx+bvRI/czhoI
         Mb4QLMr81WJRK3Wn5xNsklfk0oeomkrgJ+489uY5ZZTUPVWmI9Y1AuhC0v5MqIiJDqXO
         yZmVdtK93gHStOfZdT7gWvDL3kClBFbZq13dU=
MIME-Version: 1.0
In-Reply-To: <5e9821061002042140le7ba356s48e535c9d8b637ec@mail.gmail.com>
References: <4B6B193D.4060106@gmail.com> <3e8340491002041126l44bb28a7u8f427f0f5c05e57e@mail.gmail.com> 
	<5e9821061002042140le7ba356s48e535c9d8b637ec@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 5 Feb 2010 02:20:11 -0500
Message-ID: <3e8340491002042320y783b6e2am37d63353297e2ce1@mail.gmail.com>
Subject: Re: Intercepting system calls
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/5 Oleg Kutkov <elenbert@gmail.com>:
> Hello. l need to capture and process outgoing and incoming packets from all
> network interfaces, include virtual interfaces. So I try to overload socket
> and if_rx. I'm not found another way to do that.

Why not just use libpcap?
