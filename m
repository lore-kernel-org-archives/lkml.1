Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbYDCADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbYDCADY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbYDCACx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:02:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:60565 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbYDCACv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=di3hVKjoVNWA6hTnrETXyPMefrSISSkHK9srIjXE5+f8hyv4/AUusrwBt9X4hjO28/KqVKglGbozN2W9M8IrK/hBeCNSSVzo1zIqNAIDFs6+IeBHiXHMZtNd1eMb02lqRAKC701tp9I4ZRRPL3NzYbJC2RL7+Y0ROUkzgd5YJ1g=
Message-ID: <e64671580804021702n3e9a3a44v7042029c45d38806@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:02:51 -0500
From: "Sabuj Pattanayek" <sabujp@gmail.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       "Moore, Eric" <Eric.Moore@lsi.com>
Subject: Re: kernel exception in Fusion MPT base driver 3.04.06 (linux-2.6.24.3)
In-Reply-To: <e64671580803191636r59d0cd0ar93692dc50d852be7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e64671580803171629g534ebf34l89adbb14bb985dc7@mail.gmail.com>
	 <20080318002502.852d0f12.akpm@linux-foundation.org>
	 <47DFFE90.8050808@sgi.com>
	 <e64671580803191411r7ca57fffu885e173f9b3285d0@mail.gmail.com>
	 <e64671580803191636r59d0cd0ar93692dc50d852be7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, Mar 19, 2008 at 6:36 PM, Sabuj Pattanayek <sabujp@gmail.com> wrote:
> Hi,
>  >  >  Does the exception happen every time?
>

After going through lots of hardware (HBAs, motherboards, PSUs) it was
determined that there was a problem with the PCI-X riser in this
particular system. Sorry about the false alarm but this one was
difficult to track down.

Thanks,
Sabuj
