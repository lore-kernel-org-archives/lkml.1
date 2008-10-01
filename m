Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJAOxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJAOxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYJAOxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:53:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:48884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYJAOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KcRULQ2CyazHHo8pYMkZUpjMCQlOcFvgCPjPBa5Z+yw1CzD8Ib9vJHMC+Fv9US3PMU
         rASIDjF0QYvc2eyPAVe5BJsca8zDuXCItRl07VbhjhKDdwgYHDlzL5TtrbqNHIVTXtAg
         +YfrO1DYfQPAOkdNTJ/BXqpKrASebrVzWWFxU=
Message-ID: <86802c440810010753u5f160e22m58c8b949277eea98@mail.gmail.com>
Date: Wed, 1 Oct 2008 07:53:23 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] fix: x86: remove cpu_vendor_dev
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081001073636.GE9366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
	 <20080930193736.GA4453@mailshack.com>
	 <86802c440809301337i1bbf6e9ckb8de8a1ef08955d3@mail.gmail.com>
	 <20081001064942.GA651@elte.hu>
	 <86802c440810010022x5597655dre535aa5d4b986719@mail.gmail.com>
	 <20081001073636.GE9366@elte.hu>
X-Google-Sender-Auth: 8c0d4966ef28fdb9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> there is two copy of SECURITY_INIT
>
> indeed. I fixed this up now.
>
> interestingly, this seems to be one of the rare cases where Git
> auto-merge does the wrong thing - tt should have detected a conflict.
>

should let git guys know that.

YH
