Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYLPUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYLPUZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbYLPUWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:22:55 -0500
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:37188 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757003AbYLPUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:22:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Y8FeU5pjnQhp5iu567yWvJzPndQN+87M/egHhLCrcwXUkA5A3hsKu/EVhuHOCgSlY2M3Sq2tOtTUb1ozPo8MxBEbSkmGNdecI5iXLS//+F8eHt6ofoT42fMfACXBikw7;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] aerdrv: fix a typo in error message
Date: Tue, 16 Dec 2008 12:22:51 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, tom.l.nguyen@intel.com, yanmin.zhang@intel.com,
       linux-kernel@vger.kernel.org
References: <4938B693.80002@jp.fujitsu.com>
In-Reply-To: <4938B693.80002@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161222.52423.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 4, 2008 9:05 pm Hidetoshi Seto wrote:
> "TLP" is an acronym for "Transaction Layer Packet."
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center

