Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZCFJKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZCFJKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZCFJJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:09:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:6070 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZCFJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rPfTnPQZCEUHMorvblYaEBL5Q5dChnS7wTv92Cwh7K/+2ewnxkV9t4RHu6W1Ss5j03
         qRxjWPFlclpUzekJStfjPXAWBgkd6j82QT8Drb62A2QKh9bn3v7yRLq22XbR0QWyv4hA
         G2z+mVgSa6pSk8iyH1JfAqod8JgUzJQErybuo=
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
From: Richard Hughes <hughsient@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
In-Reply-To: <20090306005234.GA32539@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org>
	 <20090306005234.GA32539@srcf.ucam.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 09:08:56 +0000
Message-Id: <1236330536.12838.2.camel@hughsie-work.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 00:52 +0000, Matthew Garrett wrote:
> Calling the ENAB method on Toshiba laptops results in notifications 
> being sent when laptop hotkeys are pressed. This patch simply calls that 
> method and sets up an input device if it's successful.

Great news - no polling!

Definitely +1 from me.

Richard.




