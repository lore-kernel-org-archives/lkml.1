Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbYEPPLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbYEPPLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765337AbYEPPGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:06:18 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:49972 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765335AbYEPPGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:06:15 -0400
Subject: Re: [PATCH 1/67] aufs document
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <12109484013324-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp>
Content-Type: text/plain
Date: Fri, 16 May 2008 10:59:36 -0400
Message-Id: <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of comments about this. First off you might want to reconsider
how you are breaking up the patches. 67 patches seems a bit much to me
and while the separation between patches is clear it seems that some of
them can be folded. Second I'm not sure if I haven't gotten it yet or if
it wasn't sent but I am missing an Email 0/67. Typically this contains a
description of the patch set, an index of the patches (possibly with
descriptions), and a diffstat for the entire patch set. The last thing
is that each patch should have a worth wile description attached to it.
All of your comments are two lines and that may make sense based on how
you have it broken up but if you start breaking up the patch set
differently you will need better descriptions (possibly even now for
some of the more obscure functionality).

Dave

