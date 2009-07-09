Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZGIO3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZGIO3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbZGIO2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:28:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761161AbZGIO2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:28:53 -0400
Date: Thu, 9 Jul 2009 17:28:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v10 0/2] ioeventfd (formerly iosignalfd)
Message-ID: <20090709142808.GA26895@redhat.com>
References: <20090707210023.21953.22087.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707210023.21953.22087.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 05:08:38PM -0400, Gregory Haskins wrote:
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>
