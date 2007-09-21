Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXIUKsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXIUKsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbXIUKss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:48:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbXIUKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:48:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iQbixrNP7YGca9XIxAXWiIX/XgowY18QeqoS26GD17/h3+0fp9oElFKZZ5qfVwdCZonnXAfRE+kXfeuZlMV1QW+7EV6imwoUdUn6Iax5r60WeDpdE8H23sPuzYig5hil5+T8LuS/snaXvjqlByV/8NL4XEeaSrdizH62kiO1o9M=
Message-ID: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com>
Date: Fri, 21 Sep 2007 12:48:44 +0200
From: "Peter Stahlir" <peter.stahlir@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Git as a filesystem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is it possible/feasible to use git as a filesystem?
Like having git on top of ext3.

This way I could do a gitfs-gc and there is only one
pack file sitting on the disk which is a compressed
version of the whole system.
I am not interested in a version controlled filesystem,
only in the space saving aspects.

Thanks,

Peter
