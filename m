Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYJCVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYJCVZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYJCVZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:25:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36658 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbYJCVZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:25:22 -0400
Subject: Re: kexec with vmware esx 3.0.2
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, Alok Kataria <akataria@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
References: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 14:21:33 -0700
Message-Id: <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 14:08 -0700, Yinghai Lu wrote:
> anyone tried to use linux kernel to kexec vmware esx?

That would not be a recommended practice.  It might work.  It should not
be very useful.

Zach

