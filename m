Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYAWQpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYAWQpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYAWQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:44:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:38017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYAWQov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:44:51 -0500
Message-Id: <F99D5D66-3364-4414-86D3-7ED68037981C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: zippel@linux-m68k.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: kbuild question -- make sure at least one config choice is selected?
Date: Wed, 23 Jan 2008 10:44:40 -0600
Cc: linux-kbuild@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman,

I know this has come up before, but wasn't sure if any recent  
enhancements to Kconfig have resolved this issue.

We have a set of board choices in PPC land that are 'config' options.   
We want to make sure the user selects at least one of them (or force  
at least one of them to be selected).  Is there a way to do that?

thanks

- k
