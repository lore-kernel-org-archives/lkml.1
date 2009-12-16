Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZLPFbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZLPFbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZLPFbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:31:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52188 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZLPFbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P7/tWEiRGVobtrL8znucgZ6fTCRGw0b0QCMrZ64S1oaRyFFKiEjFJvlXuSY/EKBvjS
         29VQqDjo/Lf6GrjjggcWqqQk23jg5jwts8Q05WgTpdDrjYNDIA63PmxseTZtMObcG0+Q
         GpuX+vhOHRPJRaO+wAXH1A3jsQeFhF330qZgo=
Message-ID: <4B2870A4.2020202@gmail.com>
Date: Tue, 15 Dec 2009 21:31:16 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Younes Manton <younes.m@gmail.com>
CC: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm] nouveau iMac crashes and burns
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com> 	<586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com> <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
In-Reply-To: <586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hm.. any ideas i.g.
it seems renouveau requirements
needs at max 256 mb for memory
on the card(and 2.4 kernel),

looking at mmiotrace(seems the best way)
I've turned on the tracer, but as soon
as I load the module nouvaeu the system freezes!

Justin P. Mattock
