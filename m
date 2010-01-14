Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452Ab0ANSfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0ANSfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369Ab0ANSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:35:34 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57065 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab0ANSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vIr/KpQdKeD39dbjsn9/OO4yBrnpvzNPzpX4uVPH7fs97Tw/bu0ExJcJqK4ZxB9+Mw
         2RkbWSYDrCyzr/N2E8XC/lBnt/wBFNaMNHf9iRvOifglASWdpW+NH36VOywq5vul9H9h
         CAhZb+If/SXWo38TA6GcYLrQWmNA9iROSP0s4=
MIME-Version: 1.0
In-Reply-To: <4B4A2DAA.2050104@superbug.co.uk>
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
	 <4B4A2DAA.2050104@superbug.co.uk>
Date: Thu, 14 Jan 2010 10:35:32 -0800
Message-ID: <bd8e30a41001141035v7ff6ba74pba23fa07728a6da8@mail.gmail.com>
Subject: Re: Linux Serial Performance
From: "Paul G. Allen" <pgallen@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: dbarto@quakeglobal.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From some of the responses I've gotten both on and off list, it
appears the problem is most likely in the .so provided by Sun and
Seriaio. Others are getting great performance using other methods (C
applications, PC-PC connections, etc) which indicates that the Linux
serial driver is just fine. I am going to ping on Sun about this and
see about either getting it fixed or doing it myself.

Thanks,

PGA
-- 
Paul G. Allen
Random Logic Consulting
www.randomlogic.net
