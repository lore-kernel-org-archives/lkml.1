Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYHHQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYHHQJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYHHQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:09:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYHHQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:09:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qkMSo5ArAozPNHNPsvpzt2/hMCRAa6Agg+0cR0qVjsCiU6k92eKMNlcRy+vLN/X4h
	SiKPEzlHKllrnnETbMkCg==
Message-ID: <6cc912950808080909o2e6248c6qf6aae772c80c4e3@mail.gmail.com>
Date: Fri, 8 Aug 2008 09:09:38 -0700
From: "Michael Davidson" <md@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: prevent binaries from making system calls using the wrong syscall interface
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <87ljz74uzz.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080807003459.37CC629624@localhost>
	 <87ljz74uzz.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK - I did not realize that this was a "feature".

I have already submitted a one line patch to fix the audit path.
