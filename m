Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZBDEAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZBDEAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBDEAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:00:06 -0500
Received: from main.gmane.org ([80.91.229.2]:44691 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZBDEAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:00:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Finney <ben+debian@benfinney.id.au>
Subject: Re: cgroup mount point
Date: Wed, 04 Feb 2009 14:59:14 +1100
Message-ID: <87d4dyzwbx.fsf@benfinney.id.au>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au> <20090203125744.GC3788@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: eth595.vic.adsl.internode.on.net
X-Public-Key-ID: 0xBD41714B
X-Public-Key-Fingerprint: 9CFE 12B0 791A 4267 887F  520C B7AC 2E51 BD41 714B
X-Public-Key-URL: http://www.benfinney.id.au/contact/bfinney-gpg.asc
X-Post-From: Ben Finney <bignose+hates-spam@benfinney.id.au>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:+4mXHD4eMeBjgl7X3LvuF2dIjp0=
Cc: debian-devel@lists.debian.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org> writes:

> The message you quoted is from Daniel Berrange, not me.

You're right. I should have read more carefully.

> Could you also tell your rationale for not agreeing with /?

The bar for adding new required entries to the root directory is now
very high. The facility being discussed is far too specific to need a
top-level entry, especially when better alternatives have already been
suggested that fit it into the existing, more meaningful, directories.

-- 
 \       “The optimist thinks this is the best of all possible worlds. |
  `\           The pessimist fears it is true.” —J. Robert Oppenheimer |
_o__)                                                                  |
Ben Finney

