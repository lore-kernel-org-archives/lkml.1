Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYIYWR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYIYWR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIYWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:17:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:6603 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYIYWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:17:46 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Date: Thu, 25 Sep 2008 18:17:34 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20080221115452.GB13948@elte.hu> <1222320201.23524.135.camel@alok-dev1> <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251817.35030.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008 16:48, Zachary Amsden wrote:
> For example, a device made by Exploder Technologies has two ports, 3686,
> and 3687.  Read access to port 3686 returns the status register and any
> access at all to port 3687 moves the robot arm, activating the
> thermonuclear self destruct device and destroying the earth.  I have
> such a device in my basement, but I have to be careful not to issue any
> I/O to port 3687 on it, whether it is writes OR reads.

Don't give al-quieda any ideas.
