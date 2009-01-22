Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZAVPn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZAVPn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZAVPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:43:48 -0500
Received: from kuber.nabble.com ([216.139.236.158]:56327 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZAVPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:43:47 -0500
Message-ID: <21606877.post@talk.nabble.com>
Date: Thu, 22 Jan 2009 07:43:47 -0800 (PST)
From: gsmd <gsmdib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: plz help fixing lirc_igorplugusb kernel module
In-Reply-To: <4237.49788488.6c688@altium.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: gsmdib@gmail.com
References: <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com> <87c.4976ffbf.5f61c@altium.nl> <21605162.post@talk.nabble.com> <4237.49788488.6c688@altium.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dick Streefland wrote:
> 
> I suggest removing at least this line, to see if
> that helps.
> 
Well, removing the entire if (ir->buf_in[2] != 0) block leads to nothing
being displayed on key press. Only occasional GET_INFRACODE: error 0
messages.
-- 
View this message in context: http://www.nabble.com/plz-help-fixing-lirc_igorplugusb-kernel-module-tp21570131p21606877.html
Sent from the linux-kernel mailing list archive at Nabble.com.

