Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYJWVrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYJWVrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYJWVqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:46:52 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:38686 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753133AbYJWVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:46:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Z5kVVIMP3x52Wl+jcshGJ1+PrjWKaORsFLIUPqwRiThpRIZfvAPlk6VaXQ/tNuqIY93UhwWWB69eOr6dBOdEmWnLbg9NG/43D7Gn0Efv4BqRsBGTTexwrbrpLQz9iCc4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [BUG][PATCH] cpqphp: fix kernel NULL pointer dereference
Date: Thu, 23 Oct 2008 14:46:31 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alex Chiang <achiang@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48F7DB17.9020302@jp.fujitsu.com>
In-Reply-To: <48F7DB17.9020302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231446.31724.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 16, 2008 5:23 pm Kenji Kaneshige wrote:
> Hi,
>
> The following patch fixes the regression in 2.6.27 that causes
> kernel NULL pointer dereference at cpqphp driver probe time.
> This patch should be backported to the .27 stable series.

Applied, thanks.

Jesse
