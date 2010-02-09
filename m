Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0BIJZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:25:51 -0500
Received: from kuber.nabble.com ([216.139.236.158]:59966 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0BIJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:25:50 -0500
Message-ID: <27512493.post@talk.nabble.com>
Date: Tue, 9 Feb 2010 01:25:49 -0800 (PST)
From: luckygala <lucky2@libero.it>
To: linux-kernel@vger.kernel.org
Subject: Re: plz help fixing lirc_igorplugusb kernel module
In-Reply-To: <21606877.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: lucky2@libero.it
References: <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com> <87c.4976ffbf.5f61c@altium.nl> <21605162.post@talk.nabble.com> <4237.49788488.6c688@altium.nl> <21606877.post@talk.nabble.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




gsmd wrote:
> 
> 
> Dick Streefland wrote:
>> 
>> I suggest removing at least this line, to see if
>> that helps.
>> 
> Well, removing the entire if (ir->buf_in[2] != 0) block leads to nothing
> being displayed on key press. Only occasional GET_INFRACODE: error 0
> messages.
> 

i have the same problem with igorplugusb and the buffer overrun when i push
any buttons of my remote

Can anyone explain to me, in detail, how i can solve the problem?
i need the steps to made the changes that you sugested in this forum
thanks a lot
-- 
View this message in context: http://old.nabble.com/plz-help-fixing-lirc_igorplugusb-kernel-module-tp21570131p27512493.html
Sent from the linux-kernel mailing list archive at Nabble.com.

