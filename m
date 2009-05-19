Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZESNCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZESNCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZESNC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:02:26 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:53053 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZESNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MZ/NKZFlyX3g+n3swjTPUj8/MQrLvgJgnRTTRHkWvorohCtuufJZezZZyksTvt7lg3
         lE1N20B5qDMiAoARjPDqYI9pPuGvO+L96iOURX1Ksy8wQWhs0f1hHZRWX9mbpsnzP9Bc
         wJRe95iyBXi1E1AHQKhFsVaLD09w5Q+pgf88M=
MIME-Version: 1.0
In-Reply-To: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
References: <128c57bf092e08fe6372f6e8c3d02fc88b62e094.1242557192.git.richard.genoud@gmail.com>
Date: Tue, 19 May 2009 15:02:26 +0200
Message-ID: <80b317760905190602n2e4c8f6r73447b0d331d6ce8@mail.gmail.com>
Subject: Re: [PATCH 1/3] clean rspiusb code
From: Richard Genoud <richard.genoud@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Judd Montgomery <judd@jpilot.org>, Jeff Frontz <jeff.frontz@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Richard Genoud <richard.genoud@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/17 Richard Genoud <richard.genoud@gmail.com>:
> This first patch makes checkpatch happier
>
I forgot to say that this patch serie applies to Greg KH's staging
tree (<http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging>)

richard.
