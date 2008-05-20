Return-Path: <linux-kernel-owner+w=401wt.eu-S1765603AbYETLFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765603AbYETLFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYETLFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:05:09 -0400
Received: from visualserver.org ([84.242.66.126]:40540 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYETLFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:05:08 -0400
Date: Tue, 20 May 2008 13:05:01 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: Re: significance of using 2kb long byte_rev_table in lib/bitrev.c
In-Reply-To: <1211244839.5915.114.camel@brick>
Message-ID: <Pine.LNX.4.64.0805201302440.18899@visualserver.org>
References: <Pine.LNX.4.64.0805191850410.18461@visualserver.org>
 <1211244839.5915.114.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: DB2E72FB42.BEF01
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Harvey Harrison wrote:

> On Mon, 2008-05-19 at 18:59 +0200, Soumyadip Das Mahapatra wrote:
>> Hi,
>>  	i cant understand the significance of using 2kb size of
>> bit_rev_table array in lib/bitrev.c
>
> It's used in reversing the bits in a byte value as well, which your
> patch breaks (see the bitrev8 users)
>
> Harvey

Well you can do that modifying the value of k. I commented these in the
program.

Soumya

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

