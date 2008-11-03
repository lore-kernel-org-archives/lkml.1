Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYKCTsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYKCTsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKCTsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:48:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbYKCTso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:48:44 -0500
Message-ID: <490F5568.2090003@redhat.com>
Date: Mon, 03 Nov 2008 14:47:52 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, arjan@linux.intel.com
Subject: logging server C-state time?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks --

I'm interested in logging the amount of time that server CPUs spend in various 
C-states over the course of a complicated job, ideally in a manner I could sync 
up with output from sysstat tools.  So far all the tools I've seen for power 
monitoring seem to be targeted to laptops and interactive use, but I'm looking 
for something that's scriptable and doesn't need ACPI battery information, even 
if that means relying on indirect measurements of power use like C-states.  Any 
suggestions?

-- Chris
