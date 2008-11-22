Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYKVIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYKVIrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYKVIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:47:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:47055 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYKVIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sLYJSex4J+ctQhYT1BX3nz90GxSnO7XtRpuzmLWrFxK6fturVJi+lgiSwoARpdNoNq
         FECalB8g/13rUfeqJNRk+QWjD3tAE9P2hkpcpmirnnV67D6dGzg0E7JtS7izZQuLvJ3e
         tcx6N1kwC5wQL2J7Rx6T41kmfkAJXDJw7L0VU=
Message-ID: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
Date: Sat, 22 Nov 2008 16:47:10 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Steven Rostedt" <srostedt@redhat.com>
Subject: Some FTRACE related question
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Q1:   how to use ftrace to ftrace itself?   (i would like to see some
ftrace-triggered flow)   In view of the following patch:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-11/msg03745.html

Is it to prevent this from being possible?

Q2:   how to ftrace s2ram and resume?   I attempted to do it, but the
trace output is always filled with "resume" related functions when it
started up, which is only logical.





-- 
Regards,
Peter Teoh
