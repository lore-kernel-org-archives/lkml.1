Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYK3SA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYK3SA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 13:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYK3SAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 13:00:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:36349 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYK3SAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 13:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LC/VUAEESqaKvHA6cDHd87EyOhu8AqLCYldOPhll6OnoECWYVTNVWMewPJ7bu+YLo/
         9CeVr3phE5/03yH5LYRYwrreusNJr8KeyOJE61bgNOy2BHY0U1t5K2kTORqAExC9D0rq
         QuTppfmYshii2sxlgu9/QahwAGdS3vC97LHcg=
Message-ID: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com>
Date: Sun, 30 Nov 2008 23:30:19 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: keypad/touchscreen driver events latencies using LTTng on ARM?
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to try LTTng to measure the keypad and touchscreen
drivers events latency on ARM based board, which typically runs less
than 1GHz frequency.  I have recently tried LTTng patches as per
compatibility list on LTTng website on 2.6.25 kernel on ARM11 based
board, but on LTTv it shows the IRQ min/max interval times on
nanoseconds precision, would that be correct? Because I thought it
could be possible to microseconds format until with hrtimers support
right? Just guide so that I can use this tool to effectively measure
driver latencies. Thanks.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
