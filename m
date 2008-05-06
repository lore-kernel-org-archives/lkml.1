Return-Path: <linux-kernel-owner+w=401wt.eu-S934022AbYEFVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbYEFVc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933614AbYEFVZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:25:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:7609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbYEFVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DBSktKAtFtDrj0qMRTWvF3LdGxgOSaYdWHpNKYz0F8XyedzKl65tm79nG1yMc0UFjXEYZOR1EzzmwreF1ZO0RYIo4z5ORJ47W2CSjIO8i38wzrgLjRs4NM8r6LmLBQNOs0kSEGZEx4EUToBCxlj87IHRLBEX0EbkZI6nRbgfNoY=
Message-ID: <4820CCCA.6040601@gmail.com>
Date: Tue, 06 May 2008 23:25:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com
Subject: Re: [RFC v2 2/8] HID: make a bus from hid code
References: <1209296946-18454-1-git-send-email-jirislaby@gmail.com> <1209296946-18454-2-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1209296946-18454-2-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2008 01:49 PM, Jiri Slaby wrote:
> Make a bus from hid core. This is the first step for converting all the
> quirks and separate almost-drivers into real drivers attached to this bus.

If no objections I would like to merge it to hid#mm along with patch for 
module-init-tools. (I've changed apple driver little bit and need to rebase it 
to hid#mm branch.)
