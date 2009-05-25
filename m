Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZEYJ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZEYJ4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZEYJ4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:56:45 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54200 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbZEYJ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zat7mbfjK6EobxjJUVgaNKWoDWOc4beLCFvDLnN14fRa7qF9ovnGI5/tMPSd+PP7Bc
         EqUhBDP2Hmo1NORPzwha0BaUubinjN5HjNtqswFvdqo0+qCPU/4efO9zKdk9PPjtH79i
         2PQ/R8abRjGM/AdEHTRT1+flCqZyIaFKHOf9s=
Message-ID: <4A1A6B59.2030009@tuffmail.co.uk>
Date: Mon, 25 May 2009 10:56:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [Bug #13125] active uvcvideo breaks over suspend
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.B-B.0-bGKB@chimera>
In-Reply-To: <uSztiUhmDDC.A.B-B.0-bGKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13125
> Subject		: active uvcvideo breaks over suspend
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2009-04-15 10:12 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4
> Handled-By	: Ming Lei <tom.leiming@gmail.com>
> Patch		: http://lkml.org/lkml/2009/4/18/5
>   

Seems to be fixed in RC7, thanks.

