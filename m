Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZFIRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZFIRGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFIRG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:06:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZFIRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Oau+aKD3+Eo94hXhfZOB9M/xUNPmdZ3BRmwTPOgZ/gNX41Ermsq6e5YR6PFEqSh6j6
         jVIHdXwvv6LrZZYWW6nDBxLKZktc1LKZZY9SNf1sB2pOuZvs+6dAOmNUc4C4Rof+TDf5
         ElPUtdgVJop1e3+IjAMkV1srMRR7whO6urLjo=
From: Vladimir Zajac <eightgraph@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 2.6.30-rc4] thermal: fix off-by-1 error in trip point trigger condition
Date: Tue, 9 Jun 2009 19:06:21 +0200
User-Agent: KMail/1.9.9
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905061934.21821.eightgraph@gmail.com> <200906091510.11285.trenn@suse.de>
In-Reply-To: <200906091510.11285.trenn@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906091906.22162.eightgraph@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009 15:10:10 Thomas Renninger wrote:
> This one should have
> CC: stable@kernel.org
> added.
> Vladimir, do you mind submitting this one for stable inclusion
> if not done already.
> 
Inclusion into stable is not needed.
The bug was introduced in 2.6.30-rc1, stable release is not affected. 

Vladimir
