Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYESQgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYESQgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYESQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:36:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:15766 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYESQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=FsjyZkTJFyS3rHxqEnghDFywlCJl0NrHafcgLNy4Z403Qh8vw1kk/Q1QnCL7nxxy6aKJm6ELdrwRTfmmnSTvymjqzrNnwYXeTDreiZD+Cm9OrvnP3KEcC/EBarQtSDybC6JxwTf+slM9M4zuyFW/raDQiEf9PpzrWFPIVOzMS/4=
Message-ID: <4831AC83.7050908@users.sourceforge.net>
Date: Mon, 19 May 2008 18:36:19 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Shailabh Nagar <nagar@watson.ibm.com>
CC: Mark Seger <Mark.Seger@hp.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] distinct tgid/tid I/O statistics (was: taskstats and
 /proc/.../io asymmetry?)
References: <482DF0C0.6050208@users.sourceforge.net>
In-Reply-To: <482DF0C0.6050208@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Patch against 2.6.25.4, tested in KVM.

Tested in latest linux-next (next-20080519) as well.

-Andrea
