Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYCUMOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYCUMOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYCUMOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:14:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3415 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYCUMN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:13:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DJZb3Z5RNdUaO+0XRGoCn8bHv1WO0GhT4VaNy+27kgIYK2dLmRnrFT/7S4jlzCI2U
	E+N2yR3FaTLEKvSZDfgEg==
Message-ID: <d43160c70803210513q13a9341avaf952a6ce39b9f39@mail.gmail.com>
Date: Fri, 21 Mar 2008 08:13:50 -0400
From: "Ross Biro" <rossb@google.com>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2]: MM: Make Page Tables Reloctable: Conditional TLB Flush
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080321164450.4F8F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080319141829.1F2E4DC98D@localhost>
	 <20080321164450.4F8F.E1E9C6FF@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 3:56 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>  Could you rebase them for newest kernel or -mm?
>  And please remove many of "#if 1" in the second patch.
>

Sorry, the #if 1's are debugging code.  I thought I had already gotten
them all.  I've just built the latest -mm.  I'll be porting the
patches over the next couple of days.

    Ross
