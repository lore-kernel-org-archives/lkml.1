Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXCEEIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXCEEIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXCEEIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:08:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10186 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXCEEIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PxZghEZbdW50Tw1CQTk1H+PyfH1sKHv1/Nj7Lipp6nDCB+lfFyMAmN4xSK2A+o6wl4SFo39VnsmkoyH+wumcuGAPZ87wmzjlT7eZiBFWUytmgZ5d11lAZdqBelbAYZUSH0UYsnjB6Bww5L6hzVn+vfoNrTqvCCUsdOCdfSL2gto=
Message-ID: <a44ae5cd0703042008l41e74e4bj59a8d04de5074381@mail.gmail.com>
Date: Sun, 4 Mar 2007 20:08:19 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc2-mm1 -- kernel/sched.c:3384: error: 'struct rq' has no member named 'in_nohz_recently'
In-Reply-To: <a44ae5cd0703041822l777eb4adjea12cef99cf7d89c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0703041822l777eb4adjea12cef99cf7d89c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I see this was already reported.  Sorry.  My query at
marc.theaimsgroup.com didn't find the previous report.  I just
stumbled onto it while browsing for other information.

       Miles
