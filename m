Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYBAILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYBAILh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYBAIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:11:28 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:32521 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYBAIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k526FwZRloW9EWfJPPXDBfU2/JqnDtR5Sx605KMJHST1bJOu5HPS7Gqv7mlrwLQEDHik1CiEIqawIbVPp2G2QxjIPGa/aFv5RhxM/sAdGQx17sL9kbdY18wtYJbShIwvjaGPxot3bb2DIEIJ638ytTqavSO4eOFZ4ZUQhYTZacE=
Message-ID: <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
Date: Fri, 1 Feb 2008 09:11:24 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "FUJITA Tomonori" <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp,
       rdreier@cisco.com, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
> The PyX storage engine supports a scatterlist linked list algorithm that
> ...

Which parts of the PyX source code are licensed under the GPL and
which parts are closed source ? A Google query for PyX + iSCSI showed
information about licensing deals. Licensing deals can only be closed
for software that is not entirely licensed under the GPL.

Bart Van Assche.
