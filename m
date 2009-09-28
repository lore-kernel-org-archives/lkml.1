Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZI1Vcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZI1Vcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZI1Vcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:32:47 -0400
Received: from mail.crca.org.au ([67.207.131.56]:36795 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbZI1Vcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:32:46 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AC12BA8.40704@crca.org.au>
Date: Tue, 29 Sep 2009 07:33:28 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au> <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com> <4ABC80B0.5010100@crca.org.au> <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com> <4AC0234F.2080808@crca.org.au> <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com> <20090928033624.GA11191@localhost> <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com> <4AC03D9C.3020907@crca.org.au> <Pine.LNX.4.64.0909282200470.11529@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909282200470.11529@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh.

Hugh Dickins wrote:
> I suggested before that for the moment you reuse VM_MAPPED_COPY,
> and you said "Okee doke".  What changed?

I made a mistake - got stuck at the point where I wasn't sure that was
an option. Everything had gone quiet and I wanted to make some headway,
so I started trying to make some progress by working on the path I
knew would be doable.

Sorry about that.

Nigel
