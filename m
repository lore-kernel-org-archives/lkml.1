Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbZHZLM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbZHZLM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbZHZLMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:12:25 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:61336 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZHZLMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lFqRt7RkvMvE8cjN6Ir1cr8Lf1YAw9Af8T83+KxjYSDhXpoT+Rr4O041R3w+psGONy
         RWPgM353YPSXrRXjpJy2YoaXnXE42kv2Kg0dUiFGBN800nzsZY4UBu/eBK0XGRkBxj1O
         GiVFxr30d8smGiTGwJSQAcYafP4+OTKXRdnH0=
Message-ID: <4A951838.4090803@gmail.com>
Date: Wed, 26 Aug 2009 08:10:48 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13836] suspend script fails, related to stdout?
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.es.4tGlKB@chimera>
In-Reply-To: <_yaHeGjHEzG.A.es.4tGlKB@chimera>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, this is still the case, the same script (netcfg from archlinux) 
fails during boot too.

Rafael J. Wysocki wrote:

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4



