Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYLOQhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYLOQhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYLOQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:37:42 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:42355 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYLOQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:37:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TEiHKIVQ/F7iVpOlFssdv/S9+86W32soEaCCeKZKDBBosIzClh5JPr/vL3B9JCPlLc
         V7BWxvWVeaTl8OQxXaEKAn0BQA/dQmZDqzVSHqlI+IFJHtQ7todMo25r+eDIYg7kBiST
         UGmgqaj1oeDwcC2svxUmMMFawn1c9WLrT06e0=
Message-ID: <67079b830812150837o12adaa1awe40b0759bbea1f7a@mail.gmail.com>
Date: Mon, 15 Dec 2008 17:37:39 +0100
From: "Jennifer Pioch" <piochjennifer@googlemail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>, opensolaris-code@opensolaris.org,
       opensolaris-rfe@opensolaris.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Cc: "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <49428AFD.5090009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
	 <20081212152929.GM26095@parisc-linux.org>
	 <494287D4.2070909@redhat.com>
	 <20081212155113.GO26095@parisc-linux.org>
	 <49428AFD.5090009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/08, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Matthew Wilcox wrote:
>  > On the other hand, NetBSD have approximately 0% market share.
>  > We shouldn't let them lock us into making a bad decision.  Is there
>  > anyone other than NetBSD who has added these syscalls?
>
>
> Free- and OpenBSD have it too.  For Solaris I've found a feature request
>  only.  Dunno about MacOS/Darwin.  Other un*xes which are important these
>  days?

Do you know the ID of the feature request?

Jenny
-- 
Jennifer Pioch, Uni Frankfurt
