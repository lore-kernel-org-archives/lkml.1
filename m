Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYCZSQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYCZSQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYCZSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:15:56 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:52882 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYCZSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=klYhcm10NfS/D3zw4NYXln/cCcyRfJqiGxdU0RUZVbrbLA+FYe+BPV1fTWbOCeGkmO/lxm+0g7b7RCeDLeeP0VCYL8tcjqRUvkw75Y0NvZ1BLNtEB7ux9Dplf9hlYaZ4GnvUs2dao7bl6lcY69nDxaV5wWC//d38TW+gXY52J6M=
Message-ID: <a36005b50803261115s6a3aa889w42fd4890c124ee01@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:15:49 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Nicholas Miell" <nmiell@comcast.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080325075403.GH2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080320090005.GA25734@one.firstfloor.org>
	 <20080321172644.GG2346@one.firstfloor.org>
	 <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
	 <20080322071755.GP2346@one.firstfloor.org>
	 <1206170695.2438.39.camel@entropy>
	 <20080322091001.GA7264@one.firstfloor.org>
	 <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com>
	 <1206335761.2438.63.camel@entropy>
	 <a36005b50803241242r2a9b38c5s57d9ac6b084021fa@mail.gmail.com>
	 <20080325075403.GH2170@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 12:54 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  There is still the additional seek.

You've been proposing and implementing a solution which needs an
additional seek.  Don't use double standards.
