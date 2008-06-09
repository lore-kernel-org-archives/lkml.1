Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYFIKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYFIKm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYFIKmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:42:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbYFIKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UGr8KK2jZZhggfmLeuMF7U7Hf5Y4Ylay0wVfMTO/EACqLAIvSQ7Wn3xfVPgy5zBGSX
         D4XLgGa5R5u5O7CC3USDVSZDuf2DfsEtCPgg/hx3M/gxi42TfWlLCz2cn3lUkDJwJIFK
         3D/0fKBLRiesnLcQSMq0JyjgC+4UUSu+L7Bl4=
Message-ID: <484D08C9.7050900@gmail.com>
Date: Mon, 09 Jun 2008 12:41:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 01/10] modpost: add support for hid
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0806051123300.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806051123300.10085@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2008 11:26 AM, Jiri Kosina wrote:
> I have not yet pulled that branch into the branch that is pulled into -mm 
> and linux-next, there are some things that I think still need sorting out 
> -- I have sent you some feedback yesterday.

Thanks a lot for the review!
