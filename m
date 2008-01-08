Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYAHIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYAHIym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYAHIyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:54:32 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:47331 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYAHIya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:54:30 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.3.8
cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2008 00:54:16 -0800
Message-ID: <7vodbwvgsn.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.3.8 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.3.8.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.3.8.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.3.8.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.3.8-1.$arch.rpm	(RPM)

Hopefully this will be the last maintenance of 1.5.3 series, as
we are nearing -rc3 on the 1.5.4 front.

----------------------------------------------------------------

Changes since v1.5.3.7 are as follows:

David Symonds (1):
      Change from using email.com to example.com as example
      domain, as per RFC 2606.

Eric Wong (2):
      git-svn: support for funky branch and project names over HTTP(S)
      git-svn: clarify the "Ignoring error from SVN" piece

Jeff King (3):
      t9600: test cvsimport from CVS working tree
      clone: correctly report http_fetch errors
      git-send-email: avoid duplicate message-ids

Jim Meyering (1):
      config.c:store_write_pair(): don't read the byte before a
      malloc'd buffer.

Junio C Hamano (3):
      git grep shows the same hit repeatedly for unmerged paths
      git-am -i: report rewritten title
      GIT 1.5.3.8

Nguyễn Thái Ngọc Duy (3):
      Add missing inside_work_tree setting in setup_git_directory_gently
      Do check_repository_format() early
      Do check_repository_format() early (re-fix)

