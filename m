Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYAQT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYAQT2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYAQT2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:28:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYAQT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:28:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SqkbOGqLN++MJBM1lYlzReSN6/FEmgeaAMu4xUuxu/KFS+icL273c4+6LFirSsNCI
	ua561mqmGj3mO7GbdxCvA==
Message-ID: <4d47a5d10801171128t371fb3c4y27401c156f20569@mail.gmail.com>
Date: Thu, 17 Jan 2008 14:28:29 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Chris mason" <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3 conversion, and more)
Cc: btrfs-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200801171325.55406.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115105238.4fc3e992@think.oraclecorp.com>
	 <200801171325.55406.chris.mason@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 1:25 PM, Chris mason <chris.mason@oracle.com> wrote:
> So, I've put v0.11 out there.  It fixes those two problems and will also
> compile on older (2.6.18) enterprise kernels.
>
> v0.11 does not have any disk format changes.

Hi Chris,

First, massive congratulations for bringing this to fruition in such a
short time.

Now back to the regular carping: why even support older kernels?

Regards,

Daniel
