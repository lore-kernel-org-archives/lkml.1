Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYLOUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYLOUnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYLOUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:43:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39171 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYLOUn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:43:29 -0500
Message-ID: <4946C160.2090505@redhat.com>
Date: Mon, 15 Dec 2008 21:43:12 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jennifer Pioch <piochjennifer@googlemail.com>
CC: opensolaris-code@opensolaris.org, opensolaris-rfe@opensolaris.org,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>	 <20081212152929.GM26095@parisc-linux.org>	 <494287D4.2070909@redhat.com>	 <20081212155113.GO26095@parisc-linux.org>	 <49428AFD.5090009@redhat.com> <67079b830812150837o12adaa1awe40b0759bbea1f7a@mail.gmail.com>
In-Reply-To: <67079b830812150837o12adaa1awe40b0759bbea1f7a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jennifer Pioch wrote:
> On 12/12/08, Gerd Hoffmann <kraxel@redhat.com> wrote:
>> Free- and OpenBSD have it too.  For Solaris I've found a feature request
>>  only.  Dunno about MacOS/Darwin.  Other un*xes which are important these
>>  days?
> 
> Do you know the ID of the feature request?

#1167819 @ bugs.opensolaris.org

HTH,
  Gerd
