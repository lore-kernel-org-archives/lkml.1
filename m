Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZAETL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZAETL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZAETLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:11:35 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:32793 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754743AbZAETLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:11:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DMLivMDJ+xAVFbpMys++3cKAWQxwG+HBF7zjBpVC6Jw7hPXHCr8kuYAOggu0tE1hm9kBntCwJRAzN90WHMMENNO/K3PoK/no2NK+qZTrCnkCpubqCHBPm5B6V8Tsjpfp;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 8/13] drivers/pci/hotplug: Remove redundant test
Date: Mon, 5 Jan 2009 11:11:29 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812211639170.9555@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812211639170.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051111.29697.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 21, 2008 7:39 am Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> func is checked not to be NULL a few lines before.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

Applied, thanks Julia.

-- 
Jesse Barnes, Intel Open Source Technology Center

