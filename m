Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYLIWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYLIWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYLIWx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:53:56 -0500
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:35888 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754935AbYLIWxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:53:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Y3okbTBvmmLC1anQYXij+xETj5z87AJuFYdFwBfBDXLPB8Bfpp+Is6aikUdJr3qS5aqSUXDgb07ylvug/Hr5EmVzU1oTeKE8Mg8D49FPfCL+5p1inzGRfMQzSEN811u0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
Date: Tue, 9 Dec 2008 14:53:31 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091453.32105.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 08, 2008 7:19 am Jiri Slaby wrote:
> Let it as serial, since it doesn't have subdevice in the form of 0x00PS.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
