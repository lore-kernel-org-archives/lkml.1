Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZJAPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZJAPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZJAPZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:25:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbZJAPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:25:26 -0400
Message-ID: <4AC4C9D5.3000902@zytor.com>
Date: Thu, 01 Oct 2009 08:25:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu> <4AB8EAF2.1030204@zytor.com> <4AC4C8F2.5050708@redhat.com>
In-Reply-To: <4AC4C8F2.5050708@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 08:21 AM, Avi Kivity wrote:
> 
> Re-ping?
> 
> If accepted, please merge just the core patch and I will carry all of
> them in parallel.  Once tip is merged I'll drop my copy of the first patch.
> 

I was just talking to Ingo about this... would you consider this .32 or
.33 material at his time?  It came in awfully late for .32...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

