Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZGLIpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZGLIpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZGLIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:45:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbZGLIpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:45:22 -0400
Message-ID: <4A59A34F.3040206@redhat.com>
Date: Sun, 12 Jul 2009 11:48:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [KVM PATCH v10 0/2] ioeventfd (formerly iosignalfd)
References: <20090707210023.21953.22087.stgit@dev.haskins.net>
In-Reply-To: <20090707210023.21953.22087.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2009 12:08 AM, Gregory Haskins wrote:
> (Applies to kvm.git/master:3abaf217)
>
> This is v10 of the series.  For more details, please see the header to
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
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

