Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbZLQA3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbZLQA3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762942AbZLQA33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:29:29 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:39058 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762939AbZLQA32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=Qdk
	wOv5yxD/2OuQh51rQneGIUZkHRQuvMhCDlGRh1xhQYAxePScDbZzjh4ai8UH7zAQ
	uN+ty130BUdxh6ZB007IvvCfzpjq2BkrOx/rlhlEqXZ2zRluhP1QOISs7ExKmw8y
	0aH/V4hBGr1J3XL9lpUL4uoPs8uR2D+BAmLGT+r0=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.5.7
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 16 Dec 2009 16:29:14 -0800
Message-ID: <7vfx7aqw85.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 3861B1D2-EAA3-11DE-8554-B34DBBB5EC2E-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.6.5.7 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.5.7.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.5.7.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.5.7.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.6.5.7-1.fc11.$arch.rpm	(RPM)

Nothing spectacular to see here, but as I was tagging 1.6.6-rc3 today, I
wanted to push out fixes accumulated on the maintenance branch in a tagged
release.  Everything in this release is also in 1.6.6-rc3.

----------------------------------------------------------------

Changes since v1.6.5.6 are as follows:

Jeff King (1):
      ignore unknown color configuration

Johannes Sixt (1):
      help.autocorrect: do not run a command if the command given is junk

Junio C Hamano (2):
      worktree: don't segfault with an absolute pathspec without a work tree
      Git 1.6.5.7

Nanako Shiraishi (1):
      Illustrate "filter" attribute with an example

