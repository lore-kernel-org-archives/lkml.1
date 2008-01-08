Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYAHIP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYAHIP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYAHIPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:15:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17188 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYAHIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hLTNH2pJTZfrhf2K+FP4w4p1o0RdCJSHB086IvFVzM0mlWlWXPWvQbfmCcDKHnkyyMoNeReqtVsGMXgp5FU/5I1eRV528ne1Ar4Qh1JUeZoKVj9oURrVvufqVVjtmKHLkDy0ih/LS5Jo/H+TzBBS2hiGvkmICq/SOWXDObk5S7o=
Message-ID: <86802c440801080015g4e3abe86s53b8af11e0074eb6@mail.gmail.com>
Date: Tue, 8 Jan 2008 00:15:11 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kexec fail
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801072150050.28773@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801071837q1d6d63ewf095c9b497b33785@mail.gmail.com>
	 <Pine.LNX.4.64.0801072150050.28773@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 9:50 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 7 Jan 2008, Yinghai Lu wrote:
>
> > try to kexec 2.6.23 from RHEL 5.1, will get
> > Your BIOS doesn't leave a aperture memory hole
> > Please enable the IOMMU option in the BIOS setup
> > This costs you 64 MB of RAM ======> reboot
> >
> > but 2.6.24-rc7 kexec 2.6.24-rc7 is ok.
>
> BUG in 2.6.23 kexec?
>
>

yeah, that is more worse. it will cause reboot.

YH
