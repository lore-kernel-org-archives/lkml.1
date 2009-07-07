Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZGGJUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZGGJUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZGGJUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:20:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49653 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbZGGJUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:20:33 -0400
Message-ID: <4A5313F2.1080808@redhat.com>
Date: Tue, 07 Jul 2009 12:22:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [KVM PATCH v9 0/2] iosignalfd
References: <20090706202742.14222.65548.stgit@dev.haskins.net>
In-Reply-To: <20090706202742.14222.65548.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2009 11:33 PM, Gregory Haskins wrote:
> (Applies to kvm.git/master:c5b13264e)
>
> This is v9 of the series.  For more details, please see the header to
> patch 2/2.
>
> This series has been tested against the kvm-eventfd unit test, and
> appears to be functioning properly.  You can download this test here:
>
> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>
> (Note: unit test has been updated to accomodate new feature-set)
>
> Please consider for inclusion to kvm.git
>    

Looks good to me, but would appreciate a second opinion from Michael or 
anyone else who wants to review.

-- 
error compiling committee.c: too many arguments to function

