Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXJHRYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXJHRYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJHRYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:24:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:48939 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbXJHRYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:24:45 -0400
To: linux-kernel@vger.kernel.org
Subject: RFC: reviewer's statement of oversight
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 08 Oct 2007 11:24:45 -0600
Message-ID: <25555.1191864285@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Last month, at the kernel summit, there was discussion of putting a
Reviewed-by: tag onto patches to document the oversight they had
received on their way into the mainline.  That tag has made an
occasional appearance since then, but there has not yet been a
discussion of what it really means.  So it has not yet brought a whole
lot of value to the process.

As I was trying to sleep last night, it occurred to me that what we
might need is an equivalent of the DCO for the Reviewed-by tag.  To that
end, I dedicated a few minutes of my life to the following bit of text.
It's really just meant to be a starting point for the discussion.  Is
the following something close to what we understand Reviewed-by to mean? 

jon


Reviewer's statement of oversight v0.01

By offering my Reviewed-by: tag, I state that:

 (a) I have carried out a technical review of this patch to evaluate its
     appropriateness and readiness for inclusion into the mainline kernel. 

 (b) Any problems, concerns, or questions relating to the patch have been
     communicated back to the submitter.  I am satisfied with how the
     submitter has responded to my comments.

 (c) While there may (or may not) be things which could be improved with
     this submission, I believe that it is, at this time, (1) a
     worthwhile addition to the kernel, and (2) free of serious known
     issues which would argue against its inclusion.

 (d) While I have reviewed the patch and believe it to be sound, I can not
     (unless explicitly stated elsewhere) make any warranties or guarantees
     that it will achieve its stated purpose or function properly in any
     given situation.

 (e) I understand and agree that this project and the contribution are
     public and that a record of the contribution (including my Reviewed-by
     tag and any associated public communications) is maintained
     indefinitely and may be redistributed consistent with this project or
     the open source license(s) involved.
