Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYCZRXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYCZRXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbYCZRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:16:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55240 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbYCZRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:16:41 -0400
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <47EA80AC.4070204@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:16:34 -0700
Message-Id: <1206551794.7883.7.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 18:58 +0200, Avi Kivity wrote:
> Dave Hansen wrote:
> > On Wed, 2008-03-26 at 11:50 +0200, Avi Kivity wrote:
> >> Dave Hansen wrote:
> >>     
> >>> I was getting some kvm userspace crashes trying to run a Windows guest.
> >>> So, I decided to try a recent kernel (2.6.25-rc6-00333-ga4083c9)  with
> >>> the kvm kernel code that shipped with that kernel.
> >>>
> >>>       
> >> This is fixed in 2.6.25-rc7.
> >>     
> >
> > I just updated to -rc7 and re-tested.  Same symptoms:
> 
> Bad.  Which kvm userspace are you running?

~/src/kvm-userspace$ git describe
kvm-63-118-g52be1a1

-- Dave

