Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYLIWxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYLIWxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYLIWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:53:35 -0500
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:34460 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755842AbYLIWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:53:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ayCsY+u30Rk9B730M0hFSNqQt9oWZfl5z/dMcJY38NqFn46IJFkiWL8xKB4cJim1GlnSt61ipQlO86PDeWkG5OEPtOZEfNFBEw1j+huXEyRYxm8Vto3/txsM1ZhNFf/M;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH 18/31] drivers/pci: Make static
Date: Tue, 9 Dec 2008 14:53:09 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <493EA286.7080500@gmail.com> <493ED9D4.5000508@gmail.com>
In-Reply-To: <493ED9D4.5000508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091453.10076.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 09, 2008 12:49 pm Roel Kluin wrote:
> Sparse asked whether these could be static.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
