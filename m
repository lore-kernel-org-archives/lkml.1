Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZDZAJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZDZAJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 20:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZDZAJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 20:09:24 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:42241 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbZDZAJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 20:09:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=cqfpJsclmuZqs8RvCEDfmJ5UQrvmp9S8YWAYpM1JbLunRpK288JE61cattWxpWxP;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <49F3A632.1090302@earthlink.net>
Date: Sat, 25 Apr 2009 20:09:22 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: secure_tcp_sequence_number
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79a224bbfe0ea01905f1c8fb8e070793c9350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What should a module use since secure_tcp_sequence_number is no longer exported.
Would secure_tcpv6_sequence_number work Ok?

Thanks,
Steve

