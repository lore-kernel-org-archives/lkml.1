Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYLAUlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYLAUlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLAUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:41:27 -0500
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:38292 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752251AbYLAUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:41:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=fOEiay811C2fkPH9VDf87U68pE9q60OwLHT8nMc7RjapnCvspPC39aA8FA+71YlVuEO8vJtYpJi3q2H0FSQv/wkDredAWyV6VePRoGdRd+4mCr5jXh12a3fZy8H0RFWc;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2] PCI: allow pci driver to support only dynids
Date: Mon, 1 Dec 2008 12:41:24 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: greg@kroah.com, khali@linux-fr.org, miltonm@bga.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
References: <20081126033610.GB19881@sequoia.sous-sol.org>
In-Reply-To: <20081126033610.GB19881@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011241.24769.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2008 7:36 pm Chris Wright wrote:
> commit b41d6cf38e27 (PCI: Check dynids driver_data value for validity)
> requires all drivers to include an id table to try and match
> driver_data.  Before validating driver_data check driver has an id
> table.
>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Milton Miller <miltonm@bga.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Applied these to my linux-next branch, thanks Chris.

-- 
Jesse Barnes, Intel Open Source Technology Center

