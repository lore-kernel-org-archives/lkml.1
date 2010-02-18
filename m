Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab0BRRBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:01:45 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:56081 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab0BRRBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DJgiziAXP3R2CBWpnsKUUiNa2cpLJx8IzWBEhcb7xzZBmUQn0fK0SSesIKwX3TEift
         OtEin3806QatOcmuz9IIopNtRzVZol8qy3KRiujLyc7Bl3KeaMF4xte6sgClV/2jSZ5l
         vbioiv5oOACk6DEAjRCBEfrpRcwMTTwklttfw=
Message-ID: <4B7D7270.6030900@lwfinger.net>
Date: Thu, 18 Feb 2010 11:01:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3 V2] staging: r8187se: Miscellaneous cleanups
References: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net> <20100218160340.GH21785@kroah.com>
In-Reply-To: <20100218160340.GH21785@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 10:03 AM, Greg KH wrote:
> On Mon, Feb 15, 2010 at 09:10:08AM -0600, Larry Finger wrote:
> 
> Ick, I just applied your first versions of these patches.  What was the
> difference here?  Care to look at the next linux-next tree and see if I
> missed anything?
> 
> sorry about that.

The only difference was that I fixed the line-wrap problem that you noted in
your previous Emails. I had found them and resubmitted. There were no content
changes in the patches and the tree appears to be OK.

Thanks for the heads-up and sorry for the trouble, Those damned long lines from
the Realtek driver are a pain.

FYI, the rewritten driver has received a beacon, and the first few parts have
been submitted to John Linville.

Larry
