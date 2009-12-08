Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZLHPLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZLHPLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZLHPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:11:11 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60250 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbZLHPLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mAEMEWDkq35gMTwf0M6WvD6VEIj57yeARAKQY+ZFzAjkLfN6uvKEM3ZyiIZGOusJ3G
         AgbNIRu+ztpH+/BFmmytUP5hatn1jgdwFA74c+/6/Lj/hQ/qoK/OaUbS7B6oWqWU/c6L
         LrP3b7LCtg3o6N3NDM0CXXT3XciNSey/vl7NE=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: new kbuild maintainer
Date: Tue, 8 Dec 2009 16:11:12 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-00908-g6ec22f9; KDE/4.3.4; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>
References: <1260276751-19501-1-git-send-email-mmarek@suse.cz> <20091208131829.GA5195@merkur.ravnborg.org>
In-Reply-To: <20091208131829.GA5195@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912081611.12625.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 of December 2009, Sam Ravnborg wrote:
> On Tue, Dec 08, 2009 at 01:52:31PM +0100, Michal Marek wrote:
> > Sam was fine with handing over kbuild maintainership to me. The git
> > trees are already in linux-next, a merge request will follow shortly.
> 
> Yep - thanks for taken over this. Glad to see this is maintained properly.

Maybe we can get colors back in menuconfig then? ;-)
http://bugzilla.kernel.org/show_bug.cgi?id=13677

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
