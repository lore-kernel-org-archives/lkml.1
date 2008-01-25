Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYAYNky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYAYNky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYAYNko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:40:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:31377 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYAYNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:40:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U6njBKw2N/CEbGK+g5IMf9yz2i1mr0FmFSzLJi+GtF5Red+jBA4hWzUaWg0pAkuNnarECidI9vBz4CamADCtfscbSi+wyBOCepw3FydB+7J6cLXM9C7LtoHAQVeKmP5L8ftdz73M++tD4fx4iVTUxsUO98Kph83Clr0/0T6+jvw=
Message-ID: <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
Date: Fri, 25 Jan 2008 13:40:41 +0000
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Q: linux failed to execute /init?
In-Reply-To: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to boot Linux, but the /init process failed. Here is the
info:

=FF<6>/init exit code: -14
/init exit code: -14
<4>Failed to execute /init
Failed to execute /init
 <6>/sbin/init exit code: -14

Just wondering what do those different exit codes mean?

Thanks, -J
