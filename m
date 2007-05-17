Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXEQXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXEQXZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXEQXZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:25:30 -0400
Received: from mail.tmr.com ([64.65.253.246]:40367 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXEQXZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:25:30 -0400
Message-ID: <464CE4AE.3030908@tmr.com>
Date: Thu, 17 May 2007 19:26:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Scheduling tests on IPC methods, fc6, sd0.48, cfs12
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have posted the results of my initial testing, measuring IPC rates 
using various schedulers under no load, limited nice load, and heavy 
load at nice 0.

http://www.tmr.com/~davidsen/ctxbench_testing.html

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

