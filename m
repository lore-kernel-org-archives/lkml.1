Return-Path: <linux-kernel-owner+w=401wt.eu-S935658AbZDJR1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935658AbZDJR1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZDJR0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:26:48 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:46644 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938AbZDJR0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:26:47 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions 
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090410170506.GA29152@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org> <7612.1239382035@jrobl> <20090410165401.GA20673@infradead.org> <8041.1239382994@jrobl> <20090410170506.GA29152@infradead.org>
Date: Sat, 11 Apr 2009 02:26:33 +0900
Message-ID: <8416.1239384393@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig:
> No, we've always said that we want to do vfs-level union mounts, and
> at the storage summit we've actually moved forward on that and Jan
> and Val are sorting some of the remaining issues now.

VFS-level union is promising. Actually I am going to try that after aufs
in the future. I didn't know that people re-started working on union
mount. It is interesting.

I have been asked to include aufs into mainline from several people
several times. As long as you have strong NACK for aufs and reject all
union-type filesystems, I have to give up unwillingly and will answer
them "Aufs was rejected. Let's give it up."


J. R. Okajima
