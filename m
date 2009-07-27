Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZG0BzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZG0BzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZG0BzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:55:08 -0400
Received: from main.gmane.org ([80.91.229.2]:58052 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZG0BzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:55:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Chris Hills <chaz@chaz6.com>
Subject: Re: [ANNOUNCE] GIT 1.6.4-rc3
Date: Mon, 27 Jul 2009 03:54:27 +0200
Message-ID: <4A6D08D3.50404@chaz6.com>
References: <7vws5vrh93.fsf@alter.siamese.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: nobelnet.dk
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.2pre) Gecko/20090726 Shredder/3.0b4pre
In-Reply-To: <7vws5vrh93.fsf@alter.siamese.dyndns.org>
Cc: git@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/09 10:16, Junio C Hamano wrote:
 > A release candidate GIT 1.6.4.rc3 is available at the usual places
 > for testing:
 >
 >    http://www.kernel.org/pub/software/scm/git/
 >
 >    git-1.6.4.rc3.tar.{gz,bz2}			(source tarball)
 >    git-htmldocs-1.6.4.rc3.tar.{gz,bz2}		(preformatted docs)
 >    git-manpages-1.6.4.rc3.tar.{gz,bz2}		(preformatted docs)

Hi

It seems that running `make distclean` removes the configure script. Is 
this expected behavior?

Regards,

Chris

