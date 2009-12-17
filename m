Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbZLQAbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbZLQAbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763430AbZLQAbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:31:13 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:48096 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763111AbZLQAbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=P77Zy7VoVnMd2APt/xi
	RVr2uHQCXEMNzLDxonrwOeEryg3FWQX/mS63yZ39FAUOHClVpR4vXHCyslTX5YsS
	+6vVi+BMdjyrLS/ioYixHgMJvhUjsQWnwlqtolWqDtggABEs7pP9mAJfncm9y6Z7
	/1Heg1g8yXens4FuXVoxhjco=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.6.rc3
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 16 Dec 2009 16:30:57 -0800
Message-ID: <7vaaxiqw5a.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 758A6E00-EAA3-11DE-9671-DC0DEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.6.6.rc3 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.6.rc3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.6.rc3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.6.rc3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.6.6.rc3-1.fc11.$arch.rpm	(RPM)

Things have really calmed down and hopefully we can give the final release
as holiday present to everybody in time ;-)

----------------------------------------------------------------

Changes since v1.6.6-rc2 are as follows:

Björn Gustavsson (1):
      bash: Support new 'git fetch' options

Jeff King (1):
      ignore unknown color configuration

Johannes Sixt (1):
      help.autocorrect: do not run a command if the command given is junk

Junio C Hamano (7):
      Remove post-upload-hook
      Fix archive format with -- on the command line
      Git 1.6.5.6
      Update Release Notes for 1.6.6 to remove old bugfixes
      worktree: don't segfault with an absolute pathspec without a work tree
      Git 1.6.5.7
      Git 1.6.6-rc3

Nanako Shiraishi (1):
      Illustrate "filter" attribute with an example

