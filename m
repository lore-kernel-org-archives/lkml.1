Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZFYJwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZFYJwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFYJv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:51:56 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:41390 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZFYJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:51:55 -0400
Date: Thu, 25 Jun 2009 05:51:56 -0400 (EDT)
From: Jeff Arnold <jbarnold@ksplice.com>
X-X-Sender: jbarnold@vinegar-pot.mit.edu
To: linux-kernel@vger.kernel.org
cc: tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com,
       nelhage@ksplice.com, price@ksplice.com, geofft@ksplice.com
Subject: Ksplice updates for Ubuntu 9.04 Jaunty
Message-ID: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The Ksplice team [1] is now providing rebootless kernel updates for Ubuntu 
9.04 Jaunty to anyone who configures their machine to receive them [2].  
In short, users can click a few buttons and start getting all of the 
Ubuntu kernel security updates applied to their system without rebooting.  
No initial kernel changes are needed.

[1] http://www.ksplice.com
[2] http://www.ksplice.com/uptrack

I first mentioned Ksplice to the LKML in April 2008 [3], and since then 
we've submitted several rounds of Ksplice patches [4,5,6].  So far we've 
gotten various improvements related to Ksplice merged into mainline.

[3] http://lkml.org/lkml/2008/4/23/330
[4] http://lkml.org/lkml/2008/9/13/6
[5] http://lkml.org/lkml/2008/11/21/484
[6] http://lkml.org/lkml/2008/12/5/330

Ksplice applies traditional source code patches to unmodified Linux 
kernels.  It can be used to apply all of the Linux security patches over 
multiple years [7], and it can also apply reliability patches and other 
bug fixes, such as from the Linux stable tree.

[7] http://www.ksplice.com/paper

- Jeff
